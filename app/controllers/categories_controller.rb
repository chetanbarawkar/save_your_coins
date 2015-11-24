class CategoriesController < ApplicationController
	
  def index
  	@categories = Category.search(params,current_user)
  	respond_to do |format|
      format.html do
        @categories = @categories
      end
      only_columns = [:source, :entry_date, :amount, :description]
      format.xls {send_data @categories.to_xls(:only => only_columns)}
    end
	end

	def new
		@category = Category.new
	end

	def edit
		@category = Category.find(params[:id])
	end

	def create
	  @category = Category.new(category_params)
		if @category.save
			redirect_to categories_path(:q => @category.type.downcase)
		else
			render :action => "new" 
		end
	end
  
  def update
		@category = Category.find(params[:id])
		if @category.update_attributes(category_params)
			redirect_to categories_path(:q => @category.type.downcase)	
		else
			render :action => "edit"
		end
	end

	def destroy
    @category = Category.find(params[:id])
    @category_type =  @category.type.downcase
    @category.destroy
    redirect_to categories_path(:q => @category_type)
  end

	def get_drop_down_options
		val = params[:category_type]
		options = ""
		if params[:category_type] == "Income"
	    Category.income.each do |x|
	  		options +=  "<option value='#{x}'>#{x}</option>"
			end
		else
			Category.expenses.each do |x|
	  		options +=  "<option value='#{x}'>#{x}</option>"
			end
	  end
	  render :text => options
	end

	def bank_statement
	end

	protected
    def category_params
			params.require(:category).permit!
    end
end
