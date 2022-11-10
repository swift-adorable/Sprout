//
//  KakaoRestAPIModel.swift
//  Sprout
//
//  Created by Blanc on 2022/11/10.
//  Copyright © 2022 Blanc. All rights reserved.
//

import Foundation

struct KakaoRestAPIModel { }

//MARK: - [공용] 페이지 관련 메타데이터
extension KakaoRestAPIModel {
    struct MetaData: Codable {
        let totalCount: Int
        let pageableCount: Int
        let isEnd: Bool
        
        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
            case pageableCount = "pageable_count"
            case isEnd = "is_end"
        }
    }
}


//MARK: - 주소로 검색
extension KakaoRestAPIModel {
    
    struct AddressSearch: Codable {
        let documents: [Document]
        let meta: MetaData
        
    }
}

extension KakaoRestAPIModel.AddressSearch {
    
    struct Document: Codable {
        let address: Address
        let addressName: String
        let x, y: String
        
        enum CodingKeys: String, CodingKey {
            case address, x, y
            case addressName = "address_name"
        }
    }
}

extension KakaoRestAPIModel.AddressSearch.Document {
    
    struct Address: Codable {
        let addressName: String
        let region1DepthName, region2DepthName, region3DepthHName, region3DepthName: String
        let x, y: String

        enum CodingKeys: String, CodingKey {
            case addressName = "address_name"
            case region1DepthName = "region_1depth_name"
            case region2DepthName = "region_2depth_name"
            case region3DepthHName = "region_3depth_h_name"
            case region3DepthName = "region_3depth_name"
            case x, y
        }
    }
}


//MARK: - 키워드로 검색
extension KakaoRestAPIModel {
    
    struct KeywordSearch: Codable {
        let documents: [Document]
        let meta: MetaData
        
        enum codingKeys: String, CodingKey {
            case documents
            case metaData = "meta"
        }
    }
}

extension KakaoRestAPIModel.KeywordSearch {
    
    struct Document: Codable {
        let x, y: String
        let placeName, addressName: String
        
        enum CodingKeys: String, CodingKey {
            case x, y
            case placeName = "place_name"
            case addressName = "address_name"
        }
    }
    
}

//MARK: - 좌표로 주소 변환하기
extension KakaoRestAPIModel {
    struct Coord2Address: Codable {
        let documents: [Document]
        let meta: Meta
    }
}

extension KakaoRestAPIModel.Coord2Address {

    struct Document: Codable {
        let address: Address
    }

    struct Meta: Codable {
        let totalCount: Int

        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
        }
    }
}

extension KakaoRestAPIModel.Coord2Address.Document {
    
    struct Address: Codable {
        let addressName, region1DepthName, region2DepthName, region3DepthName: String

        enum CodingKeys: String, CodingKey {
            case addressName = "address_name"
            case region1DepthName = "region_1depth_name"
            case region2DepthName = "region_2depth_name"
            case region3DepthName = "region_3depth_name"
        }
    }
}
