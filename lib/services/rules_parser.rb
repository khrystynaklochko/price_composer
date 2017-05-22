class RulesParser
  LINE_REGEX = /(\S+)\s+(\d+)\s+(.*)/
  DISCOUNT_REGEX = /\S+\s+for\s+\d+\s*/

  def parse(str)
      valid_rules = str.each_line.select{|line| is_valid_rule(line)}
      Hash[valid_rules.map{|line| rules_for_one_item(line)}]
  end

  def is_valid_rule(line)
    line.match(LINE_REGEX)
  end

  def rules_for_one_item(line)
    rule_parts = line.match(LINE_REGEX).captures
    item = rule_parts.shift
    price_for_one = rule_parts.shift.to_i
    discounts = rule_parts.shift.scan(DISCOUNT_REGEX).flatten
    rules = Hash[discounts.map{|discount| parse_discount(discount)}]
    rules[1] = price_for_one
    [item, rules]
  end

  def parse_discount(discount)
    count, price = discount.match(/(\S+)\s+for\s+(\S+)/).captures
    [count.to_i, price.to_i]
  end

end
