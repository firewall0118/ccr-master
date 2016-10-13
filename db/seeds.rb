# A user can be of two types: "admin" or "regular"
User.create!(email: 'demo@gmail.com',
             password: 'qwerqwer',
             password_confirmation: 'qwerqwer',
             permission_level: 'Admin')

5.times do |i|
  User.create!(email: "demo#{i}@gmail.com",
               password: 'qwerqwer',
               password_confirmation: 'qwerqwer',
               permission_level: 'Regular')
end

# Generate a few of the base Settings

ProviderType.delete_all
ProviderType.create!(name: 'Child Care Center')
ProviderType.create!(name: 'Family Day Care Home')
ProviderType.create!(name: 'Group Family Day Care')

AgeGroup.delete_all
AgeGroup.create!(name: 'Infant'   , min: 0, max: 1)
AgeGroup.create!(name: 'Toddler'  , min: 2, max: 3)
AgeGroup.create!(name: 'Preschool' , min: 4, max: 6)
AgeGroup.create!(name: 'School', min: 7)

[
  { family_size: 2, minimum_income: 20161, maximum_income: 38200 },
  { family_size: 3, minimum_income: 25393, maximum_income: 43000 },
  { family_size: 4, minimum_income: 30613, maximum_income: 47750 },
  { family_size: 5, minimum_income: 35845, maximum_income: 51600 },
  { family_size: 6, minimum_income: 41065, maximum_income: 55400 },
  { family_size: 7, minimum_income: 46297, maximum_income: 59250 },
  { family_size: 8, minimum_income: 51517, maximum_income: 63050 }
].each do |attrs|
  Scale.create! attrs
end

# Add default settings here!

ChildcareResource.delete_all
{
  eav_rows:                '20',
  attendance_codes:        'PRESENT,HOLIDAY,TERMINATED,CHILD START DATE' +
                           ', ABSENT, CLOSED',
  company_name:            'Childcare Resources',
  company_address:         '244 W. Valley Ave., Suite 200',
  company_location:        'Birmingham, AL 35209',
  child_search_fields:     'name,last_name',
  family_search_fields:    'first_parent_last_name,second_parent_last_name',
  provider_search_fields:  'name',
  funder_search_fields:    'name',
  child_result_fields:     'id,name,last_name',
  family_result_fields:    'id,first_parent_last_name,second_parent_last_name',
  provider_result_fields:  'id,name',
  funder_result_fields:    'id,name',
}.each do |name, value|
  ChildcareResource.create! name: name, value: value
end

# ------------ SettingProviderRate -----------------

headers = %w["County Infant Toddler Preschool School"]
average_rates   = [
  [
    ['Blount',119,116,106,90,55, 55, 54, 40],
    ['Jefferson',156,149,134,124, 55, 55, 54, 40],
    ['Shelby',86,84,81,80, 55, 55, 54, 40],
    ['Walker',91,87,81,80, 55, 55, 54, 40],
    ['City of Birmingham',77,77,77,77, 55, 55, 54, 40]
  ],
  [
    ['Blount',96,94,92,86, 55, 55, 54, 40],
    ['Jefferson',121,121,121,143 ,55, 55, 54, 40],
    ['Shelby',73,73,73,73 ,55, 55, 54, 40],
    ['Walker',80,79,75,75 ,55, 55, 54, 40],
    ['City of Birmingham',77,77,77,77 ,55, 55, 54, 40]
  ],
  [
    ['Blount',103,101,94,88 ,55, 55, 54, 40],
    ['Jefferson',119,117,116,111 ,55, 55, 54, 40],
    ['Shelby',77,77,77,77 ,55, 55, 54, 40],
    ['Walker',74,73,72,71 ,55, 55, 54, 40],
    ['City of Birmingham',77,77,77,77 ,55, 55, 54, 40]
  ]
]
FactoryGirl.create :setting

ProviderType.all.each_with_index do |provider_type, i|
  average_rates[i].each do |rate|
    county = County.find_or_create_by(name: rate[0])
    CountyRate.create({
      county: county,
      provider_type: provider_type,
      full_time_infant_weekly_rate: rate[1],
      full_time_toddler_weekly_rate: rate[2],
      full_time_preschool_weekly_rate: rate[3],
      full_time_school_weekly_rate: rate[4],
      part_time_infant_weekly_rate: rate[5],
      part_time_toddler_weekly_rate: rate[6],
      part_time_preschool_weekly_rate: rate[7],
      part_time_school_weekly_rate: rate[8]
    })
  end
end

puts 'Added seed data!'
