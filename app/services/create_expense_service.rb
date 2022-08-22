class CreateExpenseService
  def record(params)
    split_type = params[:split_type]
    case split_type
    when "EQUAL"
      EqualSplitService.new(params).record
    when "PERCENTAGE"
      PercentageSplitService.new(params).record
    when "MANUAL"
      ManualSplitService.new(params).record
    else
      raise ArgumentError.new("Split type operation not supported")
    end
  end
end
