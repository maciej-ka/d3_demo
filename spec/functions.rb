def pluck_to_hash(model_class, *cols)
  User.pluck(*cols).map { |a| Hash[cols.zip a] }
end

def json_fixtures(data:[], columns:[], generate_id:false)
  data.each_with_index.map do |e,i|
    res = e.slice *columns
    res[:id] = i+1 if generate_id
    res
  end.to_json.html_safe
end

def json_parse(string)
  return if !string
  parsed = json_symbolize JSON.parse(string)
end

def json_symbolize(data)
  case data
    when Array then data.map { |e| json_symbolize e }
    when Hash then data.symbolize_keys
  end
end

require 'active_record'
ActiveRecord::Base.class_eval do
  def self.only
    raise "Expected to find one #{name} but none was found." if count == 0
    raise "Expected to find one #{name} but #{count} were found." if count > 1
    first
  end
end

# fill_many(customer)
# fill_many(customer, with: data)
# fill_many(Customer, with: data)
# fill_many(prefix: 'customer', with: data)
def fill_many(*args)
  if args.size == 1
    options = args.first
  else
    options = args.second.merge({ prefix: args.first })
    options[:prefix] = options[:prefix].model_name.param_key if options[:prefix].respond_to? :model_name
  end
  return if !options[:with]
  options[:with] = options[:with].attributes if options[:with].is_a? ActiveRecord::Base
  options[:prefix] ||= options[:with].class.model_name.param_key

  options[:with].each do |key, value|
    find(:fillable_field, "#{options[:prefix]}_#{key}", {}).try(:set, value) rescue Capybara::ElementNotFound
  end
end
alias :fill_in_many :fill_many

def wait
  sleep(0.1)
end

def click_a(text)
  find('a', text: text).click()
end

def click_css(*options)
  find(*options).click
end