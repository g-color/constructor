module Services
  module Budget
    class Copy
      def initialize(budget:, type:, name: nil, client_id: nil)
        @budget    = budget
        @type      = type
        @name      = name
        @client_id = client_id
      end

      def call
        create_new_budget
        copy_stages
        copy_files
        @new_budget
      end

      private

      def create_new_budget
        values = @budget.attributes.except('id', 'type')
        if @type == :estimate
          budget_type = Estimate
          values.merge!(
            name:        @name,
            client_id:   @client_id,
            solution_id: @budget.solution? ? @budget.id : nil
          )
        else
          budget_type = Solution
        end
        @new_budget = budget_type.create(values)
      end

      def copy_stages
        @budget.stages.includes(:stage_products).each do |stage|
          new_stage = stage.dup
          new_stage.update(budget: @new_budget)
          copy_stage_products(new_stage, stage.stage_products.order(:id).includes(:stage_product_sets))
        end
      end

      def copy_stage_products(new_stage, stage_products)
        stage_products.each do |product|
          new_product = product.dup
          new_product.update(stage: new_stage)
          copy_stage_product_sets(new_product, product.stage_product_sets.order(:id).includes(:stage_product_set_values))
        end
      end

      def copy_stage_product_sets(new_product, product_sets)
        product_sets.each do |set|
          new_set = set.dup
          new_set.update(stage_product: new_product)
          copy_stage_product_set_values(new_set, set.stage_product_set_values)
        end
      end

      def copy_stage_product_set_values(new_set, set_values)
        set_values.each do |value|
          new_value = value.dup
          new_value.update(stage_product_set: new_set)
        end
      end

      def copy_files
        estimate_files = [
          @budget.technical_files.includes(:asset_file),
          @budget.client_files.includes(:asset_file)
        ]
        estimate_files.each do |files|
          files.each do |tech_file|
            new_file = tech_file.dup
            new_file.update(budget: @new_budget)
          end
        end
      end
    end
  end
end
