```yaml
ruby {
    code => "
      if event.get('message').is_a? Hash
        event.set('[@metadata][need_json_encode]', 1)
      end
    "
  }

  if [@metadata][need_json_encode] {
      json_encode {
          source => "message"
      }  
  }
```