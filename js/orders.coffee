{ Model,
  Collection,
  Router,
  View,
  history } = Backbone

API_ROOT = 'http://localhost:5000'
_path = ( path ) ->
         API_ROOT + path

Order = Model
         .extend
                 idAttribute:
                  '_id'
                 url:
                  ->
                   '/orders/' + @id + '/status'

order = new Order
                  status:
                   'pending'

Orders = Collection
          .extend
                  model:
                   Order
                  url:
                   _path '/orders'
                  parse:
                   ( data ) ->
                    data
                     .orders

OrderRouter = Router
               .extend
                       routes:
                        '/orders/:id':
                         'getOrder'
                       getOrder:
                        ( id ) ->
                         new OrderView()

router = new OrderRouter()
history
 .start()

_.templateSettings =
  interpolate:
   ///
    \{\{
    ( . +? )
    \}\}
   ///g

ExpandedOrderView = View
                     .extend
                             el:
                              '#expanded'
                             events:
                              'click .status':
                               'edit'
                              'change .edit':
                               'update'
                              'blur .edit':
                               'close'
                             template:
                              _.template $( '#tpl-expanded' )
                                          .html()
                             initialize: ->
                              @render()
                              @model
                               .bind 'change',
                                     _.bind( @render,
                                             @ )
                             render: ->
                              @$el
                               .show()
                               .html @template @model
                                                .toJSON()
                              @input = @$ '.edit'
                              @text = @$ '.status span'
                              @
                             edit: ->
                              if @text
                                  .is ':visible'
                                @text
                                 .hide()
                                @input
                                 .val( $.trim @text
                                               .text())
                                 .show()
                                 .focus()
                             close: ->
                              @input
                               .hide()
                              @text
                               .show()
                             update: ->
                              @model
                               .save
                                     status:
                                      @input
                                       .val()

OrderView = View
             .extend
                     tagName:
                      'li'
                     events:
                      'click':
                       'expand'
                     initialize: ->
                       @model
                        .bind 'change',
                              _.bind( @render,
                                      @ )

                     template:
                      _.template $( '#tpl-order' )
                                  .html()
                     render: ->
                       @$el
                        .html @template @model
                                         .toJSON()
                       @
                     expand: ->
                       new ExpandedOrderView
                                             model:
                                              @model

order_view = new OrderView
                           model:
                            order

OrdersView = View
              .extend
                      el:
                       '#orders'
                      initialize: ->
                        @collection = new Orders()
                        @collection
                         .fetch
                                success: =>
                                 @render()
                      render: ->
                        @collection
                         .each ( order ) ->
                                @renderOrder order
                              ,
                               @
                      renderOrder:
                       ( order ) ->
                        orderView = new OrderView
                                                  model:
                                                   order
                        @$el
                         .append orderView
                                  .render()
                                  .el
ordersView = new OrdersView()
