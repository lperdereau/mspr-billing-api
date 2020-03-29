describe('Smoke test', function() {
    it('One smoke test', function() {
        cy.request('/api/vats')
        .then((resp) => {
            expect(resp.status).to.eq(200)
        })
    })
})