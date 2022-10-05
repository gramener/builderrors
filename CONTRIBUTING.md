# Contributing to builderrors

## Release

1. Update `VERSION=` in [builderrors](builderrors)

2. Test for errors

   ```bash
   bash test-builderrors.sh
   ```

3. Commit and push git repo

   ```bash
   export VERSION=1.x.x
   git commit . -m"DOC: Release $VERSION"
   git tag -a v$VERSION -m"Release $VERSION"
   git push --follow-tags
   ```

4. Build and push Docker container

   ```bash
   export VERSION=1.x.x
   docker build --tag gramener/builderrors:$VERSION --tag gramener/builderrors:latest .
   docker run --rm -v `pwd`:/mnt/repo gramener/builderrors:latest
   docker push gramener/builderrors --all-tags
   ```
