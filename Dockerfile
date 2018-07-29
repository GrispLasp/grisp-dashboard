#===========
#Build Stage
#===========
FROM bitwalker/alpine-elixir:1.6.5 as build

#Copy the source folder into the Docker image
COPY . .

#Install dependencies and build Release
RUN export MIX_ENV=prod && \
    rm -Rf _build && \
    mix deps.get && \
    mix release

#Extract Release archive to /rel for copying in next stage
RUN APP_NAME="webserver" && \
    RELEASE_DIR=`ls -d _build/prod/rel/$APP_NAME/releases/*/` && \
    mkdir /export && \
    tar -xf "$RELEASE_DIR/$APP_NAME.tar.gz" -C /export

#RUN apk --no-cache add elixir


#================
#Deployment Stage
#================
FROM pentacent/alpine-erlang-base:latest

#Set environment variables and expose port
#EXPOSE 4000
#EXPOSE 9001
#EXPOSE 4369
#EXPOSE 80 80
#ENV REPLACE_OS_VARS=true \
#    PORT=4000

#ENV REPLACE_OS_VARS=true

#Copy and extract .tar.gz Release file from the previous stage
COPY --from=build /export/ .

#Change user
USER default

#export PUBLIC_HOSTNAME=`curl -s http://169.254.169.254/latest/meta-data/public-hostname`

#Set default entrypoint and command
ENTRYPOINT ["/opt/app/bin/webserver"]

CMD ["foreground"]

#CMD ["/webserver/bin/webserver", "foreground"]
