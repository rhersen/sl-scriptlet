describe("countdown", function () {
    it("exact", function () {
        expect(getCountdown(1347566031116, 1347566030016)).toBe('1.1');
    });

    it("should round or truncate to one decimal", function () {
        expect(getCountdown(1347566031116, 1347566030010)).toBe('1.1');
    });

    it('should show ".0"', function () {
        expect(getCountdown(1347566031116, 1347566030116)).toBe('1.0');
    });

    it("should handle negative diff", function () {
        expect(getCountdown(1347566030016, 1347566031116)).toBe('-1.1');
    });

    it("should truncate the second", function () {
        expect(getCountdown(1347566031616, 1347566030010)).toBe('1.6');
    });
});

