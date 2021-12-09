configmap=(admin app-env defense-center file legacy-system-adaptor match-push-center merchant-center merchant-pc message-push metadata-config-center nginx operation-data-center order-center pay-center qualified-worker skywalking)
namespace=atai-dev
for element in ${configmap[@]}
do  
    echo $element
    kubectl get cm $element -n $namespace  -oyaml > $(pwd)/$element.yaml
done
secret=(paycrt local-ware)
for element in ${secret[@]}
do  
    echo $element
    kubectl get secret $element -n $namespace  -oyaml > $(pwd)/$element.yaml
done

