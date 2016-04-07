describe 'bundling support', ->
  it 'should export single templates', (done) ->
    view = tarima('x.js.hbs.pug', 'h1 {{x}}')

    bundle(view).render (err, result) ->
      expect(err).toBeUndefined()
      expect(result.source).toMatch /function.*?\(/
      expect(result.source).toContain 'module.exports'
      expect(result.source).not.toContain '"x":'
      expect(result.source).toContain 'require'
      done()

  it 'should export multiple templates', (done) ->
    views = [
      tarima('page.pug')
      tarima('x.js.hbs.pug', 'x {{y}}')
      tarima('x.js.ract.pug', 'a {{b}}')
    ]

    bundle(views).render (err, result) ->
      expect(err).toBeUndefined()
      expect(result.source).toMatch /function.*?\(/
      expect(result.source).toContain 'module.exports'
      expect(result.source).toContain '"x":'
      expect(result.source).toContain 'require'
      done()

  it 'should bundle modules using rollup', (done) ->
    script = tarima('module_a.js')

    bundle(script).render (err, result) ->
      path = require('path')

      expect(err).toBeUndefined()
      expect(result.dependencies).toContain path.resolve(__dirname, 'fixtures/module_b.js')

      expect(result.source).not.toContain 'require'
      expect(result.source).toContain 'return b'
      expect(result.source).toContain "var b = 'x'"
      expect(result.source).toContain 'this.a = this.a || {}'
      expect(result.source).toContain 'this.a.b = this.a.b || {}'

      done()
