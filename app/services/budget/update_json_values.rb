module Services
  module Budget
    class UpdateJsonValues
      def initialize(budget:, stages:)
        @budget = budget
        @stages = JSON.parse(stages)
      end

      def call
        update_json_stages
      end

      private

      def update_json_stages
        @budget.price_by_stage = @stages.map { |stage| stage['price'] }
        # Добавляем или обновляем этапы
        @stages.each { |s| update_stage(s) }
        @budget.calc_parameters
      end

      def update_stage(s)
        stage = @budget.stages.find_or_initialize_by(number: s['number'])
        stage.update(
          number:              s['number'],
          price:               s['price'],
          price_with_discount: s['price_with_discount'].round(2)
        )
        # Удаляем продукты которые не пришли
        product_ids = s['products'].map { |p| p['id'] }
        stage.stage_products.where.not(product_id: product_ids).destroy_all
        # Добавляем или обновляем продукты которые пришли
        s['products'].each { |p| update_product(p, stage) }
      end

      def update_product(p, stage)
        product = stage.stage_products.find_or_initialize_by(product_id: p['id'])
        product.update(quantity:           p['quantity'],
                       with_work:          p['with_work'],
                       price_with_work:    p['price_with_work']    || 0,
                       price_without_work: p['price_without_work'] || 0)
        return unless p['custom']
        # Удаляем сеты которые не пришли
        set_ids = p['sets'].map { |s| s['id'] }
        product.stage_product_sets.where.not(product_set_id: set_ids)
        # Добавляем или обновляем сеты которые пришли
        p['sets'].each { |stage_set| update_stage_set(stage_set, product) }
      end

      def update_stage_set(stage_set, product)
        set = product.stage_product_sets.find_or_initialize_by(product_set_id: stage_set['id'])
        set.update(selected: stage_set['selected'])
        # Удаляем все значения для сета которые не пришли
        item_ids = stage_set['items'].map { |i| i['id'] }
        set.stage_product_set_values.where.not(product_template_id: item_ids).destroy_all
        # Добавляем или обновляем значения для сета
        stage_set['items'].each do |i|
          value = set.stage_product_set_values.find_or_initialize_by(product_template_id: i['id'])
          value.update(
            constructor_object_id: i['value']['id'],
            quantity:              i['quantity']
          )
        end
      end
    end
  end
end
