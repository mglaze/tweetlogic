Dir[File.join(Rails.root, 'lib', '*.rb')].each do |f|
  require_dependency f
end