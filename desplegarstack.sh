stack_name="pila-fran"
template_file="main.yml"
aws cloudformation create-stack \
    --stack-name $stack_name \
    --template-body file://$template_file \
    $parameters
aws cloudformation wait stack-create-complete --stack-name $stack_name

echo "Despliegue exitoso."
