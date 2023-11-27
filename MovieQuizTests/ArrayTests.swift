//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by LERÄ on 14.11.23.
//

import XCTest //импорт фреймворк для тестирования
@testable import MovieQuiz // импорт приложения для тестирования

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws { // тест на успешное взятие элемента по индексу
        //Given
        let array = [1,1,2,3,5]
        //When
        let value = array[safe: 2]
        //Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    func testGetValueOutOfRange() throws { // тест на взятие элемента по неправильному индекс
        //Given
        let array = [1,1,2,3,5]
        //When
        let value = array[safe: 20]
        //Then
        XCTAssertNil(value)
    }
}

