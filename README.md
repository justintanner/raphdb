# RaphDB

An app for collectors to publish and edit their collectibles

## Dev Setup

### Prettier Installation

```
npm install -g @prettier/plugin-ruby@1.5.5 prettier@2.2.0 prettier-plugin-erb@0.2.0
```

A few bugs are forcing us to peg to the versions specified above:

https://github.com/adamzapasnik/prettier-plugin-erb/issues/87

https://github.com/adamzapasnik/prettier-plugin-erb/issues/44

### Prettier execution

```
prettier --write '**/*'
```

*Note:* Avoid using `rbprettier` because it does not format `.erb` files
