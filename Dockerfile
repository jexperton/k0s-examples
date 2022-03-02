FROM node:16-slim
ARG COMMIT_SHORT_HASH
ENV COMMIT $COMMIT_SHORT_HASH
COPY . /src
WORKDIR /src
CMD ["app.js"]