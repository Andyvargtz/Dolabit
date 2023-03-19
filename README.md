# Dolabit Smart Contracts

This project connects crypto with the real unbanked economy through OTC cash collection points.

Try running some of the following tasks:

```shell
npx hardhat help
npx hardhat test
REPORT_GAS=true npx hardhat test
npx hardhat node
npx hardhat run scripts/deploy.js
```

     * ESTADOS DE CONTRATO:
     * -Iniciado creado, (esperando tokens de custodia)
     * -Esperando Ya_pague (tokens depositados en custodia) ___\   unificarlos en una Tx que envia el exchange con la firma del viajero
     * -Esperando liberación (confirmación del posito)         /
     * -Liberado (Finalizado)
     * -Polemica
     *
     * ON CHAIN
     * Constructor: crearse con datos del trade (monto, forma de pago, precio, token1, divisa1)
     * Desde la app, el viajero selecciona la casa de cambio, rate, monto, divisas, forma de pago y
     * crea una "Orden" configurando los parámentros la función Crear_scrow(params).
     *
     *
     *
     * fun1: Constructor Escrow (monto, precio, exchange_id, )
     *      require msg.value = monto
     *      STATus = Iniciado
     *
     * OFFCHAIN
     *      Exchange recibe push notification
     * "RECIBIR ORDEN"
     * fun2.
     *
     *
     *  , tales precios y todo un pago del token1 a tradear y mantenerlos en custodia en el SC
     *  - mantener los fondos hasta que ocurra fun2
     *  El viajero puede cancelar
     *
     * OFF CHAIN
     * El usuario depositante
     *
