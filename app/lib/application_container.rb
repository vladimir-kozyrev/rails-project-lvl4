# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :repository_check, -> { RepositoryCheckStub }
  else
    register :repository_check, -> { RepositoryCheck }
  end
end
