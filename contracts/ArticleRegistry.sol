// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 * @title ArticleRegistry
 * @notice Records article hashes & URIs on-chain.
 */
contract ArticleRegistry {
    event ArticleSubmitted(uint256 indexed articleId, bytes32 indexed hash, string uri, address indexed author);

    uint256 public nextId;
    mapping(uint256 => bytes32) public articleHash;
    mapping(uint256 => string) public articleURI;
    mapping(uint256 => address) public authorOf;

    function submitArticle(bytes32 hash, string calldata uri) external payable returns (uint256 id) {
        id = ++nextId;
        articleHash[id] = hash;
        articleURI[id] = uri;
        authorOf[id] = msg.sender;
        emit ArticleSubmitted(id, hash, uri, msg.sender);
    }
}
