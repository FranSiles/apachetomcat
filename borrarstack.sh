stack_name="pila-fran"
aws cloudformation delete-stack --stack-name $stack_name
aws cloudformation wait stack-delete-complete --stack-name $stack_name

echo "Eliminacion exitosa."