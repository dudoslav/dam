<p align="center">
    <img alt="DAM logo" src="https://i.imgur.com/AvQ0aNs.png" width="200"/>
</p>

# DAM
Simple download manager with nice web user interface without any javascript frameworks.
DAM is build using ruby and sinatra for backend and pure HTML/CSS/JS for user interface.
Backend application is devided into API and UI.

<p align="center">
    <img alt="DAM user interface" src="https://i.imgur.com/orpGAon.jpg"/>
</p>

## Installation

### AUR

```
yaourt -S dam-git

sudo systemctl start dam
sudo systemctl enable dam
```

### From source

```
git clonse https://github.com/dudoslav/dam.git
cd dam

bundle install
bundle exec rackup # Add options like port and address
```

## API

- **GET /downloads** returns list of all active downloads.
- **GET /downloads/:id** returns status of specific download.
- **POST /downloads** starts download of file with the uri of received json body.
- **DELETE /downloads/:id** deletes specific download.
