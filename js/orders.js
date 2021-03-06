(function() {
  var Collection, ExpandedOrderView, Model, Order, OrderView, Orders, OrdersView, Router, View, history, ordersView;

  Model = Backbone.Model, Collection = Backbone.Collection, Router = Backbone.Router, View = Backbone.View, history = Backbone.history;

  Order = Model.extend({
    idAttribute: '_id',
    url: function() {
      return '/orders/' + this.id + '/status';
    }
  });

  Orders = Collection.extend({
    model: Order,
    url: '/orders',
    parse: function(data) {
      return data.orders;
    }
  });

  _.templateSettings = {
    interpolate: /\{\{(.+?)\}\}/g
  };

  ExpandedOrderView = View.extend({
    el: '#expanded',
    events: {
      'click .status': 'edit',
      'change .edit': 'update',
      'blur .edit': 'close'
    },
    template: _.template($('#tpl-expanded').html()),
    initialize: function() {
      this.render();
      return this.model.bind('change', _.bind(this.render, this));
    },
    render: function() {
      this.$el.show().html(this.template(this.model.toJSON()));
      this.input = this.$('.edit');
      this.text = this.$('.status span');
      return this;
    },
    edit: function() {
      if (this.text.is(':visible')) {
        this.text.hide();
        return this.input.val($.trim(this.text.text())).show().focus();
      }
    },
    close: function() {
      this.input.hide();
      return this.text.show();
    },
    update: function() {
      return this.model.save({
        status: this.input.val()
      });
    }
  });

  OrderView = View.extend({
    tagName: 'li',
    events: {
      'click': 'expand'
    },
    initialize: function() {
      return this.model.bind('change', _.bind(this.render, this));
    },
    template: _.template($('#tpl-order').html()),
    render: function() {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
    },
    expand: function() {
      return new ExpandedOrderView({
        model: this.model
      });
    }
  });

  OrdersView = View.extend({
    el: '#orders',
    initialize: function() {
      var _this = this;
      this.collection = new Orders();
      return this.collection.fetch({
        success: function() {
          return _this.render();
        }
      });
    },
    render: function() {
      return this.collection.each(function(order) {
        return this.renderOrder(order);
      }, this);
    },
    renderOrder: function(order) {
      var orderView;
      orderView = new OrderView({
        model: order
      });
      return this.$el.append(orderView.render().el);
    }
  });

  ordersView = new OrdersView();

}).call(this);
