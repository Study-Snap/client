# client
SwiftUI Client Application for Study Snap on iOS

## Development

Hi Liam and Sheharyaar! To use the API (develop.0.3.x +) you will need to provide access credentials to authenticate with the cloud Spaces endpoint. I can generate credentials for you, but you will need to ensure it stays off of Github. To do this, create a `.prod.env` file (since neptune is being run in prod container) and enter your credentials in the following format. Make sure this is located in the root of the client project.

```conf
SPACES_KEY=XXXXXXXXXXXXXXXXX
SPACES_SECRET=XXXXXXXXXXXXXXXXXXXXX
```

After this save it. Run `docker-compose up -d`. This will inject the credentials into the running neptune instance in the container and allow it to authenticate with the Spaces S3 API and ensure working functionality of upload, download, streaming features for the client.

If you are having trouble run the following:
```bash
docker-compose down
docker image rm studysnap/neptune:develop.0.3.x
docker volume rm client_ssdb_data
docker-compose up -d
```
