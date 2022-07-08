# frozen_string_literal: true

class RepositoryPolicy < ApplicationPolicy
  def show?
    owner?
  end

  private

  def owner?
    record.user == user
  end
end
