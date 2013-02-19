class Ruler < ActiveRecord::Base
  belongs_to :empire
  has_one :favourite_ruler, class_name: :Ruler
end
