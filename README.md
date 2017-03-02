# sigma-cloud
Sigma-cloud ...


# environment variables

see .env.sample :

NODE_QUIET=[false]
- When NODE_QUIET is set with any value other than "false", it will inform the logger to shut the heck up (useful for unit-test output). This is non-standard.


PGPROFILE=[false]
- turns the profiler on when any value (other than false) is supplied


NODE_ENV=production|testing|[development]
- NODE_ENV is a common (standard?) environment variable that is used by NPM


PORT=[8888]


TRUST_PROXY=anyvalue|[false]|0
- Setting any value tells express js to trust proxy


STATIC_DIR=local-directory-url
- the directory to find static files
- only available in development
- relative to root of project


STATIC_RURL=[/static]
- the endpoint url to serve static files
- only available in development


PGPROFILE=[false]

AWS...
AWS_ACCESS_KEY_ID=***
AWS_SECRET_ACCESS_KEY=***
AWS_REGION=[us-west-2]


Postgresql...
PGUSER=node
PGPASSWORD=xxxxxxxx
PGHOST=localhost
PGPORT=5432
PGDATABASE=node



# Development #

# etc/hosts #
Entry is automatically made in vagrant environment but you'll need to add the
same to your local hosts file:

192.168.126.126		sigmacloud.io.local

once added you can simply visit: http://sigmacloud.io.local:8888
which maps to http://192.168.126.126:8888


# debugging #

## Chrome Debugging ##

to get vagrant box built, cd into sigma-cloud/vagrant then run:

    $ vagrant up

once build, ssh into the box executing:

    $ vagrant ssh

once inside, locate the project at ~/sigma-cloud

    $ node-inspector &    # running in the background

    $ node --debug-brk server.js


goto local browser: http://sigmacloud.io.local/?port=5858


# Unit-tests #

Following the same procedure to run vagrant (above), from /events-api run:

    $ npm test

or directly with:

    $ mocha


Need to debug unit-tests? It uses the same chrome debugging routine:

    $ node-inspector & # running in the background

    $ mocha --debug-brk


goto local browser: http://sigmacloud.io.local/?port=5858
