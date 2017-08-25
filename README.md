# Consul

API для работы с Consul Service Discovery.

# Конфигурация
```
export CONSUL_URL=http://path.to.consul
export CONSUL_NAMESPACE=namespace
```

# Использование

`Consul.get('database') => { database_url: 'http://database.url', database_port: '5432' }`
