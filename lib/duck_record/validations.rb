module DuckRecord
  # = Active Record \Validations
  #
  # Active Record includes the majority of its validations from ActiveModel::Validations
  # all of which accept the <tt>:on</tt> argument to define the context where the
  # validations are active. Active Record will always supply either the context of
  # <tt>:create</tt> or <tt>:update</tt> dependent on whether the model is a
  # {new_record?}[rdoc-ref:Persistence#new_record?].
  module Validations
    extend ActiveSupport::Concern
    include ActiveModel::Validations
    
    # Runs all the validations within the specified context. Returns +true+ if
    # no errors are found, +false+ otherwise.
    #
    # Aliased as #validate.
    #
    # If the argument is +false+ (default is +nil+), the context is set to <tt>:default</tt>.
    #
    # \Validations with no <tt>:on</tt> option will run no matter the context. \Validations with
    # some <tt>:on</tt> option will only run in the specified context.
    def valid?(context = nil)
      context ||= default_validation_context
      output = super(context)
      errors.empty? && output
    end

    alias_method :validate, :valid?

    private

    def default_validation_context
      :default
    end

    def perform_validations(options = {})
      options[:validate] == false || valid?(options[:context])
    end
  end
end
