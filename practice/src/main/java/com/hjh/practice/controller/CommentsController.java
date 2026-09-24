package com.hjh.practice.controller;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CommentsController {

    @GetMapping("/comments")
    public String comments(Model model) {
        model.addAttribute("totalCount", 128);
        model.addAttribute("pendingCount", 14);
        model.addAttribute("approvedCount", 96);
        model.addAttribute("hiddenCount", 18);

        model.addAttribute("comments", List.of(
                Map.of(
                        "id", 101,
                        "author", "김관리자",
                        "postTitle", "신규 기능 안내",
                        "status", "승인됨",
                        "statusClass", "success",
                        "content", "정말 유용한 내용이네요. 운영에 바로 반영하겠습니다.",
                        "createdAt", "2026-09-25 09:10"
                ),
                Map.of(
                        "id", 102,
                        "author", "박사용자",
                        "postTitle", "서비스 개선 제안",
                        "status", "대기",
                        "statusClass", "warning",
                        "content", "메인 페이지 슬라이더가 조금 더 넓으면 좋겠습니다.",
                        "createdAt", "2026-09-25 08:42"
                ),
                Map.of(
                        "id", 103,
                        "author", "최고객",
                        "postTitle", "업데이트 일정",
                        "status", "숨김",
                        "statusClass", "neutral",
                        "content", "이번 배포 일정이 아직 안 정해진 걸로 보입니다.",
                        "createdAt", "2026-09-24 18:05"
                ),
                Map.of(
                        "id", 104,
                        "author", "정회원",
                        "postTitle", "문의 답변",
                        "status", "승인됨",
                        "statusClass", "success",
                        "content", "답변 감사합니다. 다음에도 도움이 필요하면 다시 문의하겠습니다.",
                        "createdAt", "2026-09-24 16:30"
                ),
                Map.of(
                        "id", 105,
                        "author", "이기자",
                        "postTitle", "디자인 피드백",
                        "status", "대기",
                        "statusClass", "warning",
                        "content", "버튼 간격이 조금 좁아서 모바일에서 다닥다닥 보입니다.",
                        "createdAt", "2026-09-24 11:20"
                )
        ));

        return "comments";
    }
}
