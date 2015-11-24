class Category < ActiveRecord::Base
	belongs_to :user
	belongs_to :category
	validates_presence_of :source
	validates_presence_of :entry_date
	validates_presence_of :amount, :numericality => true
	validates :type, presence: true 
	self.inheritance_column = nil
	def self.income
    ["Salary"]
  end

  def self.expenses
  	["Eating Out","Gas","Groceries","Utilities"]
  end

  def self.search(params,current_user)
  	if params[:source].present?
  		params["source_field"] = params[:source]
  	end
  	categories = current_user.categories
  	if params[:q]=="income"
  		categories = categories.where("Type=?","Income")
  		if params["source_field"].present?
  			categories = categories.where("source=?", params["source_field"])
  		end
  	elsif params[:q] == "expenses"
  		categories = categories.where("Type=?","Expenses")
  		if params["source_field"].present?
  			categories = categories.where("source=?", params["source_field"])
  		end
  	end
  	if params[:start_date].present? and params[:end_date].present? and (params["start_date"].to_date <= params["end_date"].to_date)
      categories = categories.where('Date(entry_date) IN (?)', (params["start_date"].to_date..params["end_date"].to_date))
    elsif params[:start_date].present?
      categories = categories.where('Date(entry_date) > ?', params["start_date"].to_date)
    elsif params[:end_date].present?
      categories = categories.where('Date(entry_date) < (?)', params["end_date"].to_date)
    end
    categories
  end

  def self.calculate_current_balance(current_user,val)
    if val == "current_balance"
      income_amount = current_user.categories.where("type =?","Income").sum :amount
      expenses_amount = current_user.categories.where("type =? ","Expenses").sum :amount
      current_balnce = income_amount - expenses_amount
    elsif val == "Income"
      income_amount = current_user.categories.where("type =?",val).sum :amount
    else
      expenses_amount = current_user.categories.where("type =? ",val).sum :amount
    end
  end
end
