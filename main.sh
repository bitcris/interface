!#/bin/bash

echo
echo ESCOLHA O NUMERO DA OPCAO
echo
echo 1 - CONFIGURAR INTERFACE
echo 2 - ADICIONAR INTERFACE
echo 3 - REMOVER INTERFACE
echo 4 - CRIAR UMA PONTE
echo 5 - RESETAR UMA INTERFACE
echo 6 - CRIAR UMA VLAN

read esc

case $esc in 
  1)

  echo 'SELECIONE A INTERFACE'
  read interface

  sudo ifconfig $interface down
  echo INTERFACE $interface  DESABILITADA

  echo IP DA INTERFACE $interface: 
  read ip
  echo 'MASCARA: '
  read mascara
  sudo ifconfig $interface $ip netmask $mascara

  echo NOVO IP: $ip
  echo NOVA MASCARA: $mascara
  echo 'CONFIGURADOS'

  echo 'GATEWAY: '
  read gateway
  sudo route add default gw $gateway $interface

  sudo ifconfig $interface up

  echo 'REDE CONFIGURADA'
  echo
  echo IP: $ip
  echo MASCARA: $mascara
  echo GATEWAY: $gateway
  echo

  ;;
  2)
  echo "NOME DA INTERFACE"
  read nome
  echo "TIPO EX: [bridge, vlan]"
  read tipo
  sudo ip link add $nome type $tipo
  echo INTERFACE CRIADA
  ip -c link show $nome
  ;;

  3)
    ip -c link show
    echo NOME DA INTERFACE A SER REMOVIDA
    read nome
    sudo ip link set $nome down
    sudo ip link delete $nome
    echo INTERFACE REMOVIDA
    ip -c link show 
  ;;

  4)
    ip -c link show
    echo NOME DA INTERFACE DE PONTE
    read nome
    sudo brctl addbr $nome
    echo NOME DA INTERFACE 1
    read interface1
    echo NOME DA INTERFACE 2
    read interface2
    sudo brctl addif $nome $interface1
    sudo brctl addif $nome $interface2 
    sudo ip link set $nome up
  ;;

  5)
    echo NOME DA INTERFACE A SER RESETADA
    read nome
    sudo ifconfig $nome down ; sudo ifconfig $nome 0.0.0.0 ; sudo ifconfig $nome up
    echo INTERFACE $nome RESETADA
    echo
    ip -c addr show $nome
  ;;

  6)
    echo NOME DA INTERFACE QUE A VLAN SERÁ ATRIBUIDA
    read interface
    echo NÚMERO DA VLAN QUE SERÁ ATRIBUIDA A INTERFACE $interface
    read numero
    sudo ip link add link $interface name $interface.$numero type vlan id $numero
    ifnum="$interface.$numero"
    echo
    echo $ifnum
    
    sudo ip link set dev $ifnum up

    #setando vlan
    echo IP DA VLAN 
    read ip
    echo CIDR
    read cidr
    ipcidr="$ip/$cidr"
    echo
    echo $ipcidr
    sudo ip addr add $ipcidr dev $ifnum
   ;;
esac
