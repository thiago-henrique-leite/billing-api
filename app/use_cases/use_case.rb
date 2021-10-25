module UseCase
  extend ActiveSupport::Concern

  module ClassMethods
    def perform(*args)
      new(*args).tap(&:perform)
    end
  end

  def perform
    raise NotImplementedError
  end
end