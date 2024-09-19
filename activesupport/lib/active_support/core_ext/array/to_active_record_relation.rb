# frozen_string_literal: true

class Array
  class InvalidArray < StandardError; end
  # Converts an array of ApplicationRecord objects to an ActiveRecordRelation
  #
  #   * Array must not be empty
  #   * All array items must be of the same class
  #   * All array items must be ApplicationRecord objects
  def to_active_record_relation
    raise_active_record_relation_error("array is empty") if self.empty?
    raise_active_record_relation_error("array items are not of the same class") if self.map(&:class).uniq.length > 1

    active_record_class = self.first.class

    raise_active_record_relation_error("array items are not of ApplicationRecord objects") unless active_record_class.ancestors.include? ApplicationRecord

    active_record_class.where(id: self.map(&:id))
  end

  private

  def raise_active_record_relation_error(error)
    raise InvalidArray, "Array can not be converted to an ActiveRecord::Relation because #{error}"
  end
end
