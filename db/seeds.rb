# Isolating in seperate method for better readability, for better readability
def create_admin_and_community 
  # create community
  params = {
    admin_email: "root@gmail.com",
    admin_first_name: "Super",
    admin_last_name: "Admin",
    admin_password: "rootroot",
    marketplace_country: "CA",
    marketplace_language: "en",
    marketplace_name: "JobCIE",
    marketplace_type: "service"
  }
  form = Form::NewMarketplace.new(params)

  if form.valid?
    form_hash = form.to_hash
    marketplace = MarketplaceService::API::Marketplaces.create(
      form_hash.slice(:marketplace_name,
                      :marketplace_type,
                      :marketplace_country,
                      :marketplace_language)
      .merge(payment_process: :none)
    )

    user = UserService::API::Users.create_user({
      given_name: form_hash[:admin_first_name],
      family_name: form_hash[:admin_last_name],
      email: form_hash[:admin_email],
      password: form_hash[:admin_password],
      locale: form_hash[:marketplace_language]},
      marketplace[:id]).data
  else
    puts "SOmething went wrong while creating community"
    exit
  end

  Community.last
end

if Community.all.any?
  community = Community.first
else
  community = create_admin_and_community
end

education = Category.new(translation_attributes: {en: {name: "Education"}})
education.community_id = community.id
education.save

home_help = Category.new(translation_attributes: {en: {name: "Home help"}})
home_help.community_id = community.id
home_help.save

field_project = Category.new(translation_attributes: {en: {name: "Field project"}})
field_project.community_id = community.id
field_project.save

handyman = Category.new(translation_attributes: {en: {name: "Handyman"}})
handyman.community_id = community.id
handyman.save

business = Category.new(translation_attributes: {en: {name: "Business"}})
business.community_id = community.id
business.save

professional = Category.new(translation_attributes: {en: {name: "Professional"}})
professional.community_id = community.id
professional.save

entertainment = Category.new(translation_attributes: {en: {name: "Entertainment"}})
entertainment.community_id = community.id
entertainment.save

construction = Category.new(translation_attributes: {en: {name: "Construction"}})
construction.community_id = community.id
construction.save

mechanic = Category.new(translation_attributes: {en: {name: "Mechanic"}})
mechanic.community_id = community.id
mechanic.save

sub_categories = [{parent_id: education.id, name: "Private teacher"},
                  {parent_id: education.id, name: "Dance teacher"},
                  {parent_id: education.id, name: "Music teacher"},
                  {parent_id: education.id, name: "Driving teacher"},
                  {parent_id: education.id, name: "Language teacher"},
                  {parent_id: education.id, name: "Speech therapist"},

                  {parent_id: home_help.id, name: "Nurse"},
                  {parent_id: home_help.id, name: "Beneficiary attendant"},
                  {parent_id: home_help.id, name: "Cleaning lady"},
                  {parent_id: home_help.id, name: "Window cleaner"},
                  {parent_id: home_help.id, name: "Babysitter"},
                  {parent_id: home_help.id, name: "Dog keeper"},
                  {parent_id: home_help.id, name: "Designer"},
                  {parent_id: home_help.id, name: "Mover"},
                  {parent_id: home_help.id, name: "Nutritionist"},
                  {parent_id: home_help.id, name: "Personal trainer"},
                  {parent_id: home_help.id, name: "Yoga teacher"},

                  {parent_id: field_project.id, name: "Lawn care"},
                  {parent_id: field_project.id, name: "Landscaping"},
                  {parent_id: field_project.id, name: "Snow removal"},
                  {parent_id: field_project.id, name: "Gardener"},
                  {parent_id: field_project.id, name: "Window washer"},
                  {parent_id: field_project.id, name: "Pool expert"},
                  {parent_id: field_project.id, name: "Paving pro"},
                  {parent_id: field_project.id, name: "Asphalt labourer"},

                  {parent_id: handyman.id, name: "Emergency repair"},
                  {parent_id: handyman.id, name: "Lock smith"},

                  {parent_id: business.id, name: "Sales person"},
                  {parent_id: business.id, name: "Graphic designer"},
                  {parent_id: business.id, name: "Programmer"},
                  {parent_id: business.id, name: "Assistant"},
                  {parent_id: business.id, name: "Secretary general"},

                  {parent_id: professional.id, name: "Accountant"},
                  {parent_id: professional.id, name: "Notary"},
                  {parent_id: professional.id, name: "Lawyer"},
                  {parent_id: professional.id, name: "Insurance representative"},
                  {parent_id: professional.id, name: "Realtor"},

                  {parent_id: entertainment.id, name: "Disk jockey"},
                  {parent_id: entertainment.id, name: "Party planner"},
                  {parent_id: entertainment.id, name: "Wedding planner"},
                  {parent_id: entertainment.id, name: "Magician"},
                  {parent_id: entertainment.id, name: "Clown"},
                  {parent_id: entertainment.id, name: "Animator"},
                  {parent_id: entertainment.id, name: "Photographer"},
                  {parent_id: entertainment.id, name: "Video maker"},
                  {parent_id: entertainment.id, name: "Masseuse"},
                  {parent_id: entertainment.id, name: "Makeup artist"},

                  {parent_id: construction.id, name: "General contractor"},
                  {parent_id: construction.id, name: "Carpenter"},
                  {parent_id: construction.id, name: "Painter"},
                  {parent_id: construction.id, name: "Roofer"},
                  {parent_id: construction.id, name: "Electrician"},
                  {parent_id: construction.id, name: "Plumber"},
                  {parent_id: construction.id, name: "Plasterer"},
                  {parent_id: construction.id, name: "Bricklayer"},
                  {parent_id: construction.id, name: "Welder"},

                  {parent_id: mechanic.id, name: "Car mechanic"},
                  {parent_id: mechanic.id, name: "Boat mechanic"},
                  {parent_id: mechanic.id, name: "Repairman"},
                  {parent_id: mechanic.id, name: "Repairer household appliances"},
                  {parent_id: mechanic.id, name: "Repairer commercial appliances"},
                  {parent_id: mechanic.id, name: "Repairer body shop"},
                 ]

sub_categories.each do |c|
  cat = Category.new(translation_attributes: {en: {name: c[:name]}})
  cat.community_id = community.id
  cat.parent_id = c[:parent_id]
  cat.save
end
