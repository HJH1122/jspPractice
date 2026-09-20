package com.hjh.practice;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.time.LocalDateTime;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import com.hjh.practice.dto.post.CmsPost;

@SpringBootTest
class PracticeApplicationTests {

	@Test
	void contextLoads() {
	}

	@Test
	void postUpdatedAtDisplayOmitsFractionalSeconds() {
		CmsPost post = new CmsPost();
		post.setUpdatedAt(LocalDateTime.of(2026, 9, 21, 1, 18, 1, 87_568_000));

		assertEquals("2026-09-21 01:18", post.getUpdatedAtDisplay());
	}

}
