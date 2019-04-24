# docker-stash

Docker container for [Atlassian][1] [Stash][2]

## Quick Start

The only thing really needed for this container to work correctly is to have the Stash home directory mapped into `/var/atlassian/application-data/stash`.  This is where Stash stores all of its configurations and state files.  The container also listens on ports `4990` and `4999` by default, so you will want to expose those ports as well. A simple way to start the container would be:

```sh
sudo docker run -it -d --name stash --hostname stash.example.org \
    -p 4990:4990 \
    -p 4999:4999 \
    -v /path/to/stash/home:/var/atlassian/application-data/stash \
    broadinstitute/stash
```

**Note**: The user internally to the container that runs Stash has uid/gid `1`.  Therefore, you will want to make sure all files and directories in the Stash home directory have permissions setup correctly so that Stash can read and write to/from the home directory.

[1]: https://www.atlassian.com/ "Atlassian"
[2]: https://www.atlassian.com/software/bitbucket "Stash"
