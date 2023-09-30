//
//  iSeeTests.swift
//  iSeeTests
//
//  Created by Jose Antonio on 24/3/21.
//  Copyright © 2021 Jose Antonio. All rights reserved.
//

import XCTest
@testable import iSee

class iSeeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSerieInitializationSucceeds() {
        // Zero rating
        var temp = [Temporada]();
        var cap = [Capitulo]();
        let zeroRating = Serie.init(nombre: "Cero", foto: nil, rating: 0,temporadas: temp,tempActual: 1,capActual: 1, categoria: "categoria")
        XCTAssertNotNil(zeroRating)
        
        // Highest positive rating
        let positiveRating = Serie.init(nombre: "Positiva", foto: nil, rating: 5,temporadas: temp,tempActual: 1,capActual: 1, categoria: "categoria")
        XCTAssertNotNil(positiveRating)
        
        let temporada = Temporada.init(numTemporada: 1, numCapitulos: 1, capitulos: cap)
        XCTAssertNotNil(temporada)
        
        
    }
    
    func testSerieInitializationFails() {
        var temp = [Temporada]();
        var cap = [Capitulo]();
        let negativeRating = Serie.init(nombre: "Cero", foto: nil, rating: -1,temporadas: temp,tempActual: 1,capActual: 1, categoria: "categoria")
        XCTAssertNil(negativeRating)
        
        let largeRating = Serie.init(nombre: "Cero", foto: nil, rating: 6,temporadas: temp,tempActual: 1,capActual: 1, categoria: "categoria")
        XCTAssertNil(largeRating)
    }

}
