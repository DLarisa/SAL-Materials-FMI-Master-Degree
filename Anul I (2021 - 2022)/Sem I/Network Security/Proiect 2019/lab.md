# Proiect laborator
## Configurarea `localhost` ca serviciu ascuns

### Sarcini de laborator
#### Partea 1: Accesarea unei pagini prin intermediul Tor și vizualizarea circuitului
- [Descărcați browser-ul Tor](https://www.torproject.org/download/).
**Atenție:** Dacă folosiți package manager-ul de Linux sau macOS, asigurați-vă că instalați *browser-ul*, nu (doar) `tor`. Folosiți comenzile specifice, de exemplu:
```sh
# pentru distribuțiile bazate pe Ubuntu:
sudo apt-get install torbrowser-launcher
# pentru distribuțiile bazate pe Arch:
sudo pacman -Syu tor-browser-en
yay tor-browser-en # pentru AUR Manjaro
```
Dacă instalați doar `tor`, aveți numai serviciul care vă permite să deveniți OR, nu și browser-ul. Acesta va fi necesar ulterior. Deocamdată, e nevoie de *browser*.
- Deschideți browser-ul, acceptați configurația standard (fără cenzură și proxy).
- Deschideți un URL, de exemplu [sla.cs.unibuc.ro](https://sla.cs.unibuc.ro/);
- Dați click pe (i)-ul din stînga URL-ului și puteți vedea circuitul parcurs pînă la site-ul accesat, ca [aici](https://tails.boum.org/doc/anonymous_internet/Tor_Browser/index.en.html#index5h1). Observație: Pe Windows sau macOS, este posibil ca informația să se afișeze apăsînd pe ceapa din stînga URL-ului, în loc de (i).

#### Partea 2: Configurarea `localhost` ca serviciu ascuns
- Puteți urma ghidul de [aici](https://www.makeuseof.com/tag/create-hidden-service-tor-site-set-anonymous-website-server/) pentru Windows sau [aici](https://null-byte.wonderhowto.com/how-to/host-your-own-tor-hidden-service-with-custom-onion-address-0180159/) pentru Linux.
**Sugestie:** Puteți lucra în perechi; unul dintre voi va configura adresa `.onion`, cu o pagină home simplă, iar celălalt va accesa adresa `[hash].onion` primită de la coleg.
- Dați din nou click pe (i)-ul din stînga URL-ului și veți constata că acum folosiți 3 noduri intermediare pînă la *punctul de întîlnire*, dar și serverul folosește alte 3 relee, deci în total, conexiunea are acum 6 noduri. De exemplu, vedeți [aici](https://cdn.comparitech.com/wp-content/uploads/2017/02/http-tor-service-circuit.png).

### Alte observații
- Dacă la pasul în care, după ce ați configurat hidden service, lansați:
```sh
sudo tor
```
și primiți erori care spun că portul sau serviciul este deja în uz, închideți toate procesele Tor cu comanda
```sh
killall tor
```
Pe Windows, puteți folosi Task Manager-ul.

- Laboratorul se consideră finalizat dacă ați arătat live sau în screenshot:
1. Accesarea unui site oarecare folosind Tor Browser și puteți vedea cele 3 noduri pînă la site;
2. Fie configurarea serviciului `[hash].onion`, unde arătați rezultatul comenzii:
```sh
cat /var/lib/tor/hidden_service/hostname
# rezultat, de exemplu: 9asd78a9s7dasd8.onion
```
fie accesați cu Tor Browser adresa `.onion` creată de un coleg și arătați conexiunea care folosește acum 6 noduri.

Rezultatele trebuie să arate [așa](https://www.ghacks.net/wp-content/uploads/2015/04/tor-circuit.jpg) pentru accesul direct la un site (vedeți cele 3 noduri) sau [așa](https://img.deepweb-sites.com/wp-content/uploads/2017/03/DuckDuckGo-Tor-Relay.png) pentru accesul la adresa `.onion`.
