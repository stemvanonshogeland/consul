require "rails_helper"

describe "Migration tasks" do
  describe "valuation_taggins" do
    let(:run_rake_task) do
      Rake::Task["migrations:valuation_taggings"].reenable
      Rake.application.invoke_task("migrations:valuation_taggings")
    end

    it "updates taggings" do
      valuation_tagging = create(:tagging, context: "valuation")
      another_valuation_tagging = create(:tagging, context: "valuation")
      valuation_tags_tagging = create(:tagging, context: "valuation_tags")
      tags_tagging = create(:tagging)

      run_rake_task

      expect(valuation_tagging.reload.context).to eq "valuation_tags"
      expect(another_valuation_tagging.reload.context).to eq "valuation_tags"
      expect(valuation_tags_tagging.reload.context).to eq "valuation_tags"
      expect(tags_tagging.reload.context).to eq "tags"
    end
  end

  describe "budget_admins_and_valuators" do
    let(:run_rake_task) do
      Rake::Task["migrations:budget_admins_and_valuators"].reenable
      Rake.application.invoke_task("migrations:budget_admins_and_valuators")
    end

    let(:old_budget) { create(:budget) }
    let(:current_budget) { create(:budget) }

    it "assigns administrators from existing investments" do
      harold = create(:administrator)
      john = create(:administrator)
      root = create(:administrator)

      create(:budget_investment, budget: old_budget, administrator: john)
      create(:budget_investment, budget: old_budget, administrator: harold)
      create(:budget_investment, budget: old_budget, administrator: nil)

      create(:budget_investment, budget: current_budget, administrator: root)

      run_rake_task

      expect(old_budget.administrators).to match_array [john, harold]
      expect(current_budget.administrators).to match_array [root]
    end

    it "assigns valuators from existing investments" do
      tyrion = create(:valuator)
      cersei = create(:valuator)
      jaime = create(:valuator)

      create(:budget_investment, budget: old_budget, valuators: [cersei])
      create(:budget_investment, budget: old_budget, valuators: [jaime, cersei])
      create(:budget_investment, budget: old_budget, valuators: [])

      create(:budget_investment, budget: current_budget, valuators: [tyrion, jaime])

      run_rake_task

      expect(old_budget.valuators).to match_array [cersei, jaime]
      expect(current_budget.valuators).to match_array [tyrion, jaime]
    end
  end

  describe "add_name_to_existing_budget_phases" do
    let(:run_rake_task) do
      Rake::Task["migrations:add_name_to_existing_budget_phases"].reenable
      Rake.application.invoke_task("migrations:add_name_to_existing_budget_phases")
    end

    it "adds the name to existing budget phases" do
      budget = create(:budget)
      informing_phase = budget.phases.informing
      accepting_pahse = budget.phases.accepting
      Budget::Phase::Translation.find_by(budget_phase_id: informing_phase.id).update_columns(name: "")
      expect(informing_phase.name).to eq ""
      expect(accepting_pahse.name).to eq "Accepting projects"

      run_rake_task

      expect(informing_phase.reload.name).to eq "Information"
      expect(accepting_pahse.reload.name).to eq "Accepting projects"
    end
  end

  describe "budget_phases_summary_to_description" do
    let(:run_rake_task) do
      Rake::Task["migrations:budget_phases_summary_to_description"].reenable
      Rake.application.invoke_task("migrations:budget_phases_summary_to_description")
    end

    it "appends the content of summary to the content of description" do
      budget = create(:budget)
      budget_phase = budget.phases.informing
      budget_phase.update!(
        description_en: "English description",
        description_es: "Spanish description",
        name_es: "Spanish name",
        summary_en: "English summary")

      run_rake_task

      budget_phase.reload
      expect(budget_phase.description_en).to eq "English description<br>English summary"
      expect(budget_phase.description_es).to eq "Spanish description"
      expect(budget_phase.summary_en).to eq nil
    end
  end

  describe "migrate_map_location_settings" do
    let(:run_rake_task) do
      Rake::Task["migrations:migrate_map_location_settings"].reenable
      Rake.application.invoke_task("migrations:migrate_map_location_settings")
    end
    let(:default_latitude)  { MapLocation.default_latitude }
    let(:default_longitude) { MapLocation.default_longitude }
    let(:default_zoom)      { MapLocation.default_zoom }

    it "copies the all the location data from settings to the new model" do
      Setting["map.latitude"] = latitude = -10
      Setting["map.longitude"] = longitude = 20
      Setting["map.zoom"] = zoom = 8

      run_rake_task

      expect(Map.default.map_location.latitude).not_to eq default_latitude
      expect(Map.default.map_location.longitude).not_to eq default_longitude
      expect(Map.default.map_location.zoom).not_to eq default_zoom

      expect(Map.default.map_location.latitude).to eq latitude.to_f
      expect(Map.default.map_location.longitude).to eq longitude.to_f
      expect(Map.default.map_location.zoom).to eq zoom.to_i
    end

    it "copies only the latitude location data from settings to the new model" do
      Setting["map.latitude"] = latitude = -10

      run_rake_task

      expect(Map.default.map_location.latitude).not_to eq default_latitude

      expect(Map.default.map_location.latitude).to eq latitude.to_f
      expect(Map.default.map_location.longitude).to eq default_longitude
      expect(Map.default.map_location.zoom).to eq default_zoom
    end

    it "copies only the longitude location data from settings to the new model" do
      Setting["map.longitude"] = longitude = 20

      run_rake_task

      expect(Map.default.map_location.longitude).not_to eq default_longitude

      expect(Map.default.map_location.latitude).to eq default_latitude
      expect(Map.default.map_location.longitude).to eq longitude.to_f
      expect(Map.default.map_location.zoom).to eq default_zoom
    end

    it "copies only the zoom location data from settings to the new model" do
      Setting["map.zoom"] = zoom = 8

      run_rake_task

      expect(Map.default.map_location.zoom).not_to eq default_zoom

      expect(Map.default.map_location.latitude).to eq default_latitude
      expect(Map.default.map_location.longitude).to eq default_longitude
      expect(Map.default.map_location.zoom).to eq zoom.to_i
    end

    it "deletes the location settings after running the task" do
      Setting["map.latitude"] = -10
      Setting["map.longitude"] = 20
      Setting["map.zoom"] = 8

      run_rake_task

      expect(Setting["map.latitude"]).to be nil
      expect(Setting["map.longitude"]).to be nil
      expect(Setting["map.zoom"]).to be nil
    end

    it "does nothing if there is no location data in settings" do
      run_rake_task

      expect(Map.default.map_location.latitude).to eq default_latitude
      expect(Map.default.map_location.longitude).to eq default_longitude
      expect(Map.default.map_location.zoom).to eq default_zoom
    end
  end
end
