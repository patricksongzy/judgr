module ApplicationHelper
  def get_translations(scope)
    I18n.backend.send(:init_translations) unless I18n.backend.initialized?
    translations = I18n.backend.send(:translations)
    translations[I18n.locale].with_indifferent_access[scope]
  end
end
