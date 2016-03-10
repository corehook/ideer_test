@application.factory 'Alerts', [ 'Notification', (Notification)->
  class Alerts
    alerts = []

    alerts: -> alerts

    success: (message) ->
      alert =
        message: message
        alert_type: 'success'

      alerts.push alert
      Notification.success(message, positionY: 'top', positionX: 'right')

    error: (message) ->
      alert =
        message: message
        alert_type: 'error'

      alerts.push alert
      Notification.error(message, positionY: 'top', positionX: 'right')


    server_error: -> @error('Не удалось отправить запрос!')

    messages: (messages) -> @success(alert) for alert in messages if messages
    errors: (errors) -> @error(alert) for alert in errors if errors

  new Alerts()
]