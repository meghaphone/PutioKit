//
//  FileTests.swift
//  
//
//  Created by Stephen Radford on 09/01/2017.
//
//

import XCTest
@testable import PutioKit

class FileTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        
        Putio.testing = true
    }
    
    let data: [String:Any] = [
        "id": 1234,
        "name": "A lovely movie file.mp4",
        "is_shared": true,
        "is_mp4_available": true,
        "parent_id": 92,
        "size": 1024,
        "content_type": "video/mp4",
        "first_accessed_at": 83664758,
        "created_at": "2018-01-09 09:59:00",
        "screenshot": "http://example.com/screenshot.png"
    ]
    
    func testJSONInitializer() {
        let file = File(json: data)
        
        XCTAssertEqual(file.id, 1234)
        XCTAssertEqual(file.name, "A lovely movie file.mp4")
        XCTAssertEqual(file.isShared, true)
        XCTAssertEqual(file.hasMP4, true)
        XCTAssertEqual(file.parentID, 92)
        XCTAssertEqual(file.size, 1024)
        XCTAssertEqual(file.contentType, "video/mp4")
        XCTAssertEqual(file.accessed, true)
        XCTAssertEqual(file.createdAt, "2018-01-09 09:59:00")
        XCTAssertEqual(file.screenshot, "http://example.com/screenshot.png")
    }
    
    func testHlsPlaylist() {
        
        let file = File(json: data)
        XCTAssertNil(file.hlsPlaylist)
        
        Putio.accessToken = "abc123"
        
        XCTAssertEqual(file.hlsPlaylist, "https://api.put.io/v2/files/1234/hls/media.m3u8?oauth_token=abc123&subtitle_key=all")
    }
    
    // MARK: - Global Methods
    
    func testGetFiles() {
        
        MockRequest.shared.statusCode = 200
        
        let file = File(json: data)
        
        MockRequest.shared.value = [
            "files": [data]
        ]
        
        let expect = expectation(description: "Array of files is returned")
        
        Putio.getFiles { files, error in
            XCTAssertNil(error, "Error was not nil")
            XCTAssertEqual(files.first?.name, file.name)
            XCTAssertEqual(files.first?.id, file.id)
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }
    
    func testDelete() {
        
        let file = File(json: data)
        
        MockRequest.shared.value = "Success"
        MockRequest.shared.statusCode = 200
        
        let expect = expectation(description: "Response will be okay")
        
        Putio.delete(files: [file]) { completed in
            XCTAssertTrue(completed)
            
            expect.fulfill()
        }
        
        MockRequest.shared.statusCode = 500
        
        let expect2 = expectation(description: "Response will be bad")
        
        Putio.delete(files: [file]) { completed in
            XCTAssertFalse(completed)
            
            expect2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }
    
    func testMove() {
        
        let file = File(json: data)
        
        MockRequest.shared.value = "Success"
        MockRequest.shared.statusCode = 200
        
        let expect = expectation(description: "Response will be okay")
        
        Putio.move(files: [file], to: 123) { completed in
            XCTAssertTrue(completed)
            
            expect.fulfill()
        }
        
        MockRequest.shared.statusCode = 500
        
        let expect2 = expectation(description: "Response will be bad")
        
        Putio.move(files: [file], to: 123) { completed in
            XCTAssertFalse(completed)
            
            expect2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }
    
    func testCreate() {
        
        MockRequest.shared.value = "Success"
        MockRequest.shared.statusCode = 200
        
        let expect = expectation(description: "Response will be okay")
        
        Putio.create(folder: "New Folder") { completed in
            XCTAssertTrue(completed)
            
            expect.fulfill()
        }
        
        MockRequest.shared.statusCode = 500
        
        let expect2 = expectation(description: "Response will be bad")
        
        Putio.create(folder: "New Folder") { completed in
            XCTAssertFalse(completed)
            
            expect2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }
    
    func testShareFiles() {
        
        MockRequest.shared.value = ["status": "OK"]
        MockRequest.shared.statusCode = 200
       
        let file = File(json: data)
        
        let expect = expectation(description: "Response will be okay")
        
        Putio.share(files: [file], with: ["steve", "kyle"]) { completed in
            XCTAssertTrue(completed)
            
            expect.fulfill()
        }
        
        MockRequest.shared.statusCode = 500
        
        let expect2 = expectation(description: "Response will be bad")
        
        Putio.share(files: [file], with: ["steve", "kyle"]) { completed in
            XCTAssertFalse(completed)
            
            expect2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }
    
    
    // MARK: - Model Methods
    
    func testRename() {
        
        let file = File(json: data)
        
        MockRequest.shared.value = "Success"
        MockRequest.shared.statusCode = 200
        
        let expect = expectation(description: "Response will be okay")
        
        file.rename(name: "New filename") { completed in
            XCTAssertTrue(completed)
            
            expect.fulfill()
        }
        
        MockRequest.shared.statusCode = 500
        
        let expect2 = expectation(description: "Response will be bad")
        
        file.rename(name: "Hellow world") { completed in
            XCTAssertFalse(completed)
            
            expect2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }
    
    func testGetProgress() {
        
        let file = File(json: data)
        
        MockRequest.shared.value = [
            "file": [
                "start_from": 123
            ]
        ]
        
        let expect = expectation(description: "Response will return 123")
        
        file.getProgress { progress in
            XCTAssertEqual(progress, 123)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }
    
    func testConvertToMp4() {
    
        let file = File(json: data)
        
        MockRequest.shared.value = "Success"
        
        let expect = expectation(description: "Response will be okay")
        
        file.convertToMp4 { completed in
            XCTAssertTrue(completed)
            
            expect.fulfill()
        }
        
        MockRequest.shared.statusCode = 500
        
        let expect2 = expectation(description: "Response will be bad")
        
        file.convertToMp4 { completed in
            XCTAssertFalse(completed)
            
            expect2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }
    
    func testGetMp4Status() {
        let file = File(json: data)
        
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = [
            "mp4": [
                "status": "PREPARING",
                "percent_done": 22
            ]
        ]
        
        let expect = expectation(description: "Response will be successful")
        
        file.getMp4Status { status, percentage in
            XCTAssertEqual(status, MP4Status.preparing)
            XCTAssertEqual(percentage, 22)
            
            expect.fulfill()
        }
        
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = [
            "mp4": [:]
        ]
        
        let expect2 = expectation(description: "Response will be unknown")
        
        file.getMp4Status { status, percentage in
            XCTAssertEqual(status, MP4Status.unknown)
            XCTAssertEqual(percentage, 0)
            
            expect2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
    }
    
    func testGetSharedWith() {
        
        let file = File(json: data)
        
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = [
            "shared-with": [
                [
                    "user_name": "John Doe",
                    "user_avatar_url": "https://gravatar.com/avatars/johndoe.png",
                    "share_id": 3913572317
                ]
            ]
        ]
        
        let expect = expectation(description: "A successful response")
        
        file.getSharedWith { friends, error in
            XCTAssertNil(error)
            XCTAssertNotNil(friends.first)
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }
    
    func testUnshareFile() {
        
        let file = File(json: data)
        let friend = Friend(json: [
            "user_name": "John Doe",
            "user_avatar_url": "https://gravatar.com/avatars/johndoe.png",
            "share_id": 3913572317
        ])
        
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = ["status": "OK"]
        
        let expect = expectation(description: "A successful response")
        
        file.unshare(with: [friend]) { completed in
            XCTAssertTrue(completed)
            expect.fulfill()
        }
        
        MockRequest.shared.statusCode = 401
        MockRequest.shared.value = ["status": "FAIL"]
        
        let expect2 = expectation(description: "A fail response")
        
        file.unshare(with: [friend]) { completed in
            XCTAssertFalse(completed)
            expect2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }
    
    func testGetSubtitles() {
        
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = [
            "default": "V7mVadfvq34erarjy9tqj0435hgare",
            "status": "OK",
            "subtitles": [
                [
                    "key": "V7mVafQ73r9902cjgbdfkvj2094css",
                    "language": "English",
                    "name": "MySubtitle2.srt",
                    "source": "mkv"
                ],
                [
                    "key": "V7mVadfvq34erarjy9tqj0435hgare",
                    "language": nil,
                    "name": "MySubtitle1.srt",
                    "source": "folder"
                ],
                [
                    "key": "V7mVafQ7LC_B7FKcG3pELfos2URzh8I",
                    "language": "English",
                    "name": "MySubtitle3.srt",
                    "source": "opensubtitles"
                ]
            ]
        ]
        
        let expect = expectation(description: "A successful response")
        
        let file = File(json: data)
        
        file.getSubtitles { subtitles, defaultSubtitle, error in
            
            XCTAssertNotNil(defaultSubtitle)
            XCTAssertEqual(defaultSubtitle?.key, "V7mVadfvq34erarjy9tqj0435hgare")
            XCTAssertEqual(subtitles.count, 3)
            XCTAssertNil(error)
            
            expect.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }
    
    func testSetVideoPosition() {
        
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = ["status": "OK"]
        
        let expect = expectation(description: "A successful response")
        
        let file = File(json: data)
        file.setVideo(position: 123) { completed in
            XCTAssertTrue(completed)
            expect.fulfill()
        }
        
        let expect2 = expectation(description: "A failed response")
        
        MockRequest.shared.statusCode = 500
        MockRequest.shared.value = ["status": "FAIL"]
        
        file.setVideo(position: 123) { completed in
            XCTAssertFalse(completed)
            expect2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }
    
    func testDeleteVideoPosition() {
        
        MockRequest.shared.statusCode = 200
        MockRequest.shared.value = ["status": "OK"]
        
        let expect = expectation(description: "A successful response")
        
        let file = File(json: data)
        file.deleteVideoPosition { completed in
            XCTAssertTrue(completed)
            expect.fulfill()
        }
        
        let expect2 = expectation(description: "A failed response")
        
        MockRequest.shared.statusCode = 500
        MockRequest.shared.value = ["status": "FAIL"]
        
        file.deleteVideoPosition { completed in
            XCTAssertFalse(completed)
            expect2.fulfill()
        }
        
        waitForExpectations(timeout: 1) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
    }
    
}
