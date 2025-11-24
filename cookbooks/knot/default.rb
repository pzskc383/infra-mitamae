# Knot DNS cookbook

module KnotHelpers
  def dns_serial
    now = Time.now
    midnight = Time.new(now.year, now.month, now.day, 0, 0, 0)
    part = ((now.to_i - midnight.to_i) * 99 / 86_400)
    Kernel.format("%s%02d", now.strftime("%Y%m%d"), part)
  end
end

MItamae::RecipeContext.include(KnotHelpers)
