echo "HiddenServiceDir ./hidden_service" >> ./hidden_service/torrc
echo "HiddenServicePort 80 127.0.0.1:9050" >> ./hidden_service/torrc
tor -f ./hidden_service
