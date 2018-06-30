//
//  CryptoSwift
//
//  Copyright (C) 2014-2017 Marcin Krzyżanowski <marcin@krzyzanowskim.com>
//  This software is provided 'as-is', without any express or implied warranty.
//
//  In no event will the authors be held liable for any damages arising from the use of this software.
//
//  Permission is granted to anyone to use this software for any purpose,including commercial applications, and to alter it and redistribute it freely, subject to the following restrictions:
//
//  - The origin of this software must not be misrepresented; you must not claim that you wrote the original software. If you use this software in a product, an acknowledgment in the product documentation is required.
//  - Altered source versions must be plainly marked as such, and must not be misrepresented as being the original software.
//  - This notice may not be removed or altered from any source or binary distribution.
//

import XCTest
@testable import CryptoSwift

class PBKDF: XCTestCase {

    func testPBKDF1() {
        let password: Array<UInt8> = [0x70, 0x61, 0x73, 0x73, 0x77, 0x6f, 0x72, 0x64]
        let salt: Array<UInt8> = [0x78, 0x57, 0x8e, 0x5a, 0x5d, 0x63, 0xcb, 0x06]
        let value = try! PKCS5.PBKDF1(password: password, salt: salt, iterations: 1000, keyLength: 16).calculate()
        XCTAssertEqual(value.toHexString(), "dc19847e05c64d2faf10ebfb4a3d2a20")
    }

    func testPBKDF2() {
        // P = "password", S = "salt", c = 1, dkLen = 20
        XCTAssertEqual([0x0c, 0x60, 0xc8, 0x0f, 0x96, 0x1f, 0x0e, 0x71, 0xf3, 0xa9, 0xb5, 0x24, 0xaf, 0x60, 0x12, 0x06, 0x2f, 0xe0, 0x37, 0xa6],
                       try PKCS5.PBKDF2(password: [0x70, 0x61, 0x73, 0x73, 0x77, 0x6f, 0x72, 0x64], salt: [0x73, 0x61, 0x6c, 0x74], iterations: 1, keyLength: 20, variant: .sha1).calculate())

        // P = "password", S = "salt", c = 2, dkLen = 20
        XCTAssertEqual([0xea, 0x6c, 0x01, 0x4d, 0xc7, 0x2d, 0x6f, 0x8c, 0xcd, 0x1e, 0xd9, 0x2a, 0xce, 0x1d, 0x41, 0xf0, 0xd8, 0xde, 0x89, 0x57],
                       try PKCS5.PBKDF2(password: [0x70, 0x61, 0x73, 0x73, 0x77, 0x6f, 0x72, 0x64], salt: [0x73, 0x61, 0x6c, 0x74], iterations: 2, keyLength: 20, variant: .sha1).calculate())

        // P = "password", S = "salt", c = 4096, dkLen = 20
        XCTAssertEqual([0x4b, 0x00, 0x79, 0x01, 0xb7, 0x65, 0x48, 0x9a, 0xbe, 0xad, 0x49, 0xd9, 0x26, 0xf7, 0x21, 0xd0, 0x65, 0xa4, 0x29, 0xc1],
                       try PKCS5.PBKDF2(password: [0x70, 0x61, 0x73, 0x73, 0x77, 0x6f, 0x72, 0x64], salt: [0x73, 0x61, 0x6c, 0x74], iterations: 4096, keyLength: 20, variant: .sha1).calculate())

        // P = "password", S = "salt", c = 16777216, dkLen = 20
        // Commented because it takes a lot of time with Debug build to finish.
        // XCTAssertEqual([0xee, 0xfe, 0x3d, 0x61, 0xcd, 0x4d, 0xa4, 0xe4, 0xe9, 0x94, 0x5b, 0x3d, 0x6b, 0xa2, 0x15, 0x8c, 0x26, 0x34, 0xe9, 0x84],
        //               try PKCS5.PBKDF2(password: [0x70, 0x61, 0x73, 0x73, 0x77, 0x6F, 0x72, 0x64], salt: [0x73, 0x61, 0x6C, 0x74], iterations: 16777216, keyLength: 20, variant: .sha1).calculate())

        // P = "passwordPASSWORDpassword", S = "saltSALTsaltSALTsaltSALTsaltSALTsalt", c = 4096, dkLen = 25
        XCTAssertEqual([0x3d, 0x2e, 0xec, 0x4f, 0xe4, 0x1c, 0x84, 0x9b, 0x80, 0xc8, 0xd8, 0x36, 0x62, 0xc0, 0xe4, 0x4a, 0x8b, 0x29, 0x1a, 0x96, 0x4c, 0xf2, 0xf0, 0x70, 0x38],
                       try PKCS5.PBKDF2(password: [0x70, 0x61, 0x73, 0x73, 0x77, 0x6f, 0x72, 0x64, 0x50, 0x41, 0x53, 0x53, 0x57, 0x4f, 0x52, 0x44, 0x70, 0x61, 0x73, 0x73, 0x77, 0x6f, 0x72, 0x64], salt: [0x73, 0x61, 0x6c, 0x74, 0x53, 0x41, 0x4c, 0x54, 0x73, 0x61, 0x6c, 0x74, 0x53, 0x41, 0x4c, 0x54, 0x73, 0x61, 0x6c, 0x74, 0x53, 0x41, 0x4c, 0x54, 0x73, 0x61, 0x6c, 0x74, 0x53, 0x41, 0x4c, 0x54, 0x73, 0x61, 0x6c, 0x74], iterations: 4096, keyLength: 25, variant: .sha1).calculate())

        // P = "pass\0word", S = "sa\0lt", c = 4096, dkLen = 16
        XCTAssertEqual([0x56, 0xfa, 0x6a, 0xa7, 0x55, 0x48, 0x09, 0x9d, 0xcc, 0x37, 0xd7, 0xf0, 0x34, 0x25, 0xe0, 0xc3],
                       try PKCS5.PBKDF2(password: [0x70, 0x61, 0x73, 0x73, 0x00, 0x77, 0x6f, 0x72, 0x64], salt: [0x73, 0x61, 0x00, 0x6c, 0x74], iterations: 4096, keyLength: 16, variant: .sha1).calculate())
    }

    func testPBKDF2Length() {
        let password: Array<UInt8> = "s33krit".bytes
        let salt: Array<UInt8> = "nacl".bytes
        let value = try! PKCS5.PBKDF2(password: password, salt: salt, iterations: 2, keyLength: 8, variant: .sha1).calculate()
        XCTAssertEqual(value.toHexString(), "a53cf3df485e5cd9")
    }

    #if !CI
        func testPerformance() {
            let password: Array<UInt8> = "s33krit".bytes
            let salt: Array<UInt8> = "nacl".bytes
            measure {
                _ = try! PKCS5.PBKDF2(password: password, salt: salt, iterations: 65536, keyLength: 32, variant: .sha1).calculate()
            }
        }
    #endif

    static func allTests() -> [(String, (PBKDF) -> () -> Void)] {
        var tests = [
            ("testPBKDF1", testPBKDF1),
            ("testPBKDF2", testPBKDF2),
            ("testPBKDF2Length", testPBKDF2Length),
        ]

        #if !CI
            tests += [("testPerformance", testPerformance)]
        #endif

        return tests
    }
}
