section "Creating DEMO homepage widgets" do

  card = Widget::Card.create!(link_url: "https://demo.democrateam.com/budgets",
                              header: true,
                              created_at: "01/08/2019",
                              updated_at: "01/08/2019",
                              columns: 4,
                              label: "",
                              title: "Vote the participatory budgeting!",
                              description: "You have 100 million euros to imagine a new city",
                              link_text: "Vote")

  card.image = Image.create!(imageable: card,
                             title: card.title,
                             attachment: File.new(Rails.root.join("public", "images", "homepage_card.jpg")),
                             user_id: 1)

  card = Widget::Card.create!(link_url: "https://demo.democrateam.com/legislation/processes/2/draft_versions/1",
                              header: false,
                              created_at: "01/08/2019",
                              updated_at: "01/08/2019",
                              columns: 4,
                              label: "",
                              title: "Comment the Animal protection ordinance",
                              description: "Give your opinion about the new Regulatory Ordinance of the tenancy and protection of the animals.",
                              link_text: "Comment the text")

  card.image = Image.create!(imageable: card,
                             title: card.title,
                             attachment: File.new(Rails.root.join("public", "images", "card_4.jpg")),
                             user_id: 1)

  card = Widget::Card.create!(link_url: "https://demo.democrateam.com/polls/refurbishment-of-the-north-square",
                              header: false,
                              created_at: "01/08/2019",
                              updated_at: "01/08/2019",
                              columns: 4,
                              label: "",
                              title: "Decide which should be the new square",
                              description: "This is one of the 10 squares that have been selected for a possible remodeling to improve its use for the population.",
                              link_text: "Decide the new square")

  card.image = Image.create!(imageable: card,
                             title: card.title,
                             attachment: File.new(Rails.root.join("public", "images", "card_3.jpg")),
                             user_id: 1)

  Widget::Feed.create!(kind: "proposals",
                       limit: 2,
                       created_at: "01/08/2019",
                       updated_at: "01/08/2019")
  Widget::Feed.create!(kind: "debates",
                       limit: 3,
                       created_at: "01/08/2019",
                       updated_at: "01/08/2019")
  Widget::Feed.create!(kind: "processes",
                       limit: 1,
                       created_at: "01/08/2019",
                       updated_at: "01/08/2019")
end
