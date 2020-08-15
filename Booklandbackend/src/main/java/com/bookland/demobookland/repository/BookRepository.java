package com.bookland.demobookland.repository;

import com.bookland.demobookland.model.Book;
import com.bookland.demobookland.model.projections.BookDetailsProjection;
import com.bookland.demobookland.model.projections.ExplorePageProjection;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BookRepository extends PagingAndSortingRepository<Book, Integer>, JpaSpecificationExecutor<Book> {

    Page<ExplorePageProjection> findAllProjectedBy(Pageable paging);

    Long countBookByCategoryEquals(String category);

    Long countBookByInHotListEquals(Integer hotList);

    @Query("SELECT DISTINCT b.category FROM Book b")
    List<String> findDistinctByCategory();

    @Query("SELECT DISTINCT b.subCategory FROM Book b")
    List<String> findDistinctBySubCategory();

    BookDetailsProjection findByBookId(Integer id);

    Page<ExplorePageProjection> findTop10ByOrderByReleasedTimeDesc(Pageable paging);

    List<ExplorePageProjection> findTop10ByOrderByReleasedTimeDesc();

    Page<ExplorePageProjection> findByCategoryEquals(Pageable paging, String category);

    Page<ExplorePageProjection> findByInHotListEquals(Pageable paging, Integer hotList);

    List<ExplorePageProjection> findTop10ByInHotListEquals(Integer hotList);

    Page<ExplorePageProjection> findByRealIsbn(Pageable paging, Long isbn);

    List<ExplorePageProjection> findByRealIsbn(Long isbn);

    Page<ExplorePageProjection> findByAuthorContainsOrBookNameContainsOrCategoryContainsOrSubCategoryContains(Pageable paging, String searchedItem, String searchedItem1, String searchedItem2, String searchedItem3);

    List<ExplorePageProjection> findByAuthorContainsOrBookNameContainsOrCategoryContainsOrSubCategoryContains(String searchedItem, String searchedItem1, String searchedItem2, String searchedItem3);

    List<ExplorePageProjection> findTop10ByAuthorContainsOrBookNameContainsOrCategoryContainsOrSubCategoryContains(String searchedItem, String searchedItem1, String searchedItem2, String searchedItem3);
}
