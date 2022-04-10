module BudgetsHelper
  def budget_voting_styles_select_options
    Budget::VOTING_STYLES.map do |style|
      [Budget.human_attribute_name("voting_style_#{style}"), style]
    end
  end

  def heading_name_and_price_html(heading, budget)
    tag.div do
      concat(heading.name + " ")
      if budget.show_money?
        concat(tag.span(budget.formatted_heading_price(heading)))
      end
    end
  end

  def csv_params
    csv_params = params.clone.merge(format: :csv)
    csv_params = csv_params.to_unsafe_h.map { |k, v| [k.to_sym, v] }.to_h
    csv_params.delete(:page)
    csv_params
  end

  def budget_phases_select_options(budget)
    budget.phases.enabled.map(&:kind).map { |ph| [t("budgets.phase.#{ph}"), ph] }
  end

  def budget_currency_symbol_select_options
    Budget::CURRENCY_SYMBOLS.map { |cs| [cs, cs] }
  end

  def namespaced_budget_investment_path(investment, options = {})
    case namespace
    when "management"
      management_budget_investment_path(investment.budget, investment, options)
    else
      budget_investment_path(investment.budget, investment, options)
    end
  end

  def namespaced_budget_investment_vote_path(investment, options = {})
    case namespace
    when "management"
      vote_management_budget_investment_path(investment.budget, investment, options)
    else
      vote_budget_investment_path(investment.budget, investment, options)
    end
  end

  def css_for_ballot_heading(heading)
    return "" if current_ballot.blank? || @current_filter == "unfeasible"

    current_ballot.has_lines_in_heading?(heading) ? "is-active" : ""
  end

  def current_ballot
    Budget::Ballot.find_by(user: current_user, budget: @budget)
  end

  def unfeasible_or_unselected_filter
    ["unselected", "unfeasible"].include?(@current_filter)
  end

  def budget_published?(budget)
    budget.published? || current_user&.administrator?
  end

  def budget_map_locations(budget)
    return unless budget.present?

    if budget.publishing_prices_or_later? && budget.investments.selected.any?
      investments = budget.investments.selected
    else
      investments = budget.investments
    end

    MapLocation.where(investment_id: investments).map(&:json_data)
  end

  def display_calculate_winners_button?(budget)
    budget.balloting_or_later?
  end

  def calculate_winner_button_text(budget)
    if budget.investments.winners.empty?
      t("admin.budgets.winners.calculate")
    else
      t("admin.budgets.winners.recalculate")
    end
  end

  def display_support_alert?(investment)
    current_user &&
    !current_user.voted_in_group?(investment.group) &&
    investment.group.headings.count > 1
  end

  def budget_subnav_items_for(budget)
    {
      results:    t("budgets.results.link"),
      #stats:      t("stats.budgets.link"),
      #executions: t("budgets.executions.link")
    }.select { |section, _| can?(:"read_#{section}", budget) }.map do |section, text|
      {
        text: text,
        url:  send("budget_#{section}_path", budget),
        active: controller_name == section.to_s
      }
    end
  end

  def budget_phase_name(phase)
    phase.name.presence || t("budgets.phase.#{phase.kind}")
  end

  def budget_new_step_phases?(step)
    step == "phases"
  end

  def budget_new_step_group?(step)
    step == "groups" || step == "headings" || step == "phases"
  end

  def budget_new_step_headings?(step)
    step == "headings" || step == "phases"
  end

  def budget_single?(budget)
    budget.groups.headings.count == 1
  end

  def class_for_form(resource)
    unless @mode == "single" || resource.errors.any?
      "hide"
    end
  end

  def budget_investments_total_supports(user, budget)
    Vote.where(votable_type: "Budget::Investment",
               votable_id: budget.investments.map(&:id),
               vote_flag: true,
               voter_id: user.id).count
  end
end
