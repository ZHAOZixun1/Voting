pragma solidity ^0.8.0;

contract Voting {
    struct Voter {
    bool voted; 
    uint vote;   // 投票选项的索引 
    }

 struct Proposal {
     string name;   // 投票主题的名称 
     string description;  // 投票主题的描述
     uint voteCount; // 投票的总数
    }

 address public chairperson; // 管理员地址
    mapping(address => Voter) public voters; // 投票人地址映射到投票人信息
    Proposal[] public proposals; // 投票主题列表

    constructor() {
        chairperson = msg.sender; // 部署合约的账户为管理员 
    
    }

    // 添加投票主题
    function addProposal(string memory name, string memory description) public {
        require(msg.sender == chairperson, "Only the chairperson can add proposals.");
        proposals.push(Proposal({
            name: name,
            description: description,
            voteCount:0
        }));
    }

    // 获取投票主题的数量 
    function getProposalCount() public view returns (uint) 
    {
        return proposals.length;
    }

 // 投票 
 function vote(uint proposalIndex) public {
     Voter storage sender = voters[msg.sender];
     require(!sender.voted, "Already voted.");
     require(proposalIndex < proposals.length, "Proposal does not exist.");
     sender.voted = true;
     sender.vote = proposalIndex;
     proposals[proposalIndex].voteCount +=1;
    }

    // 检查某个地址是否已投票
    function hasVoted(address voter) public view returns (bool) {
        return voters[voter].voted;
    }

 // 结算投票结果 
 function settle() public {
     require(msg.sender == chairperson, "Only the chairperson can settle the vote.");
     uint winningProposalIndex = 0;
        for (uint i = 0; i < proposals.length; i++) {
            if (proposals[i].voteCount > proposals[winningProposalIndex].voteCount) {
                winningProposalIndex = i;
            }
        }
        for (uint i = 0; i < proposals.length; i++) {
            if (i == winningProposalIndex) {
                // 奖励积分 // 这里假设奖励的积分为投票数
                // 实际情况中应该有更多的安全措施，避免出现恶意行为
                uint reward = proposals[i].voteCount;
                // 这里使用了address.transfer()函数来转账 // 更好的做法是使用安全的转账库
                payable(msg.sender).transfer(reward);
 }
 }
 }
}
