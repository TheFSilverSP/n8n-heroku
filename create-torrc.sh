echo "HiddenServiceDir ./hidden_service" >> ./hidden_service/torrc
echo "HiddenServicePort 9050 127.0.0.1:$PORT" >> ./hidden_service/torrc
tor -f ./hidden_service
