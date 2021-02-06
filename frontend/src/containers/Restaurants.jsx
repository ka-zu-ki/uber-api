import React, { useEffect, useReducer } from 'react'
import { fetchRestaurants } from "../apis/restaurants";
import { 
  initialState,
  restaurantsActionTypes,
  restaurantsReducer
} from "../reducers/restaurants";
import { REQUEST_STATE } from '../constants';

import { Link } from "react-router-dom";
import styled from 'styled-components';
import MainLogo from '../images/logo.png';
import MainCoverImage from '../images/main-cover-image.png'
import RestaurantImage from '../images/restaurant-image.jpg';
import Skeleton from '@material-ui/lab/Skeleton'

const Restaurants = () => {
  const [state, dispatch] = useReducer(restaurantsReducer, initialState)

  useEffect(() => {
    dispatch({ type: restaurantsActionTypes.FETCHING })
    fetchRestaurants()
    .then((data) => {
      dispatch({ 
        type: restaurantsActionTypes.FETCH_SUCCESS,
        // 通信に含まれるデータのことをペイロードデータということから慣例的に付ける
        payload: {
          restaurants: data.restaurants
        }
      })

    })
  }, [])

  return (
    <>
      <HeaderWrapper>
        <MainLogoImage src={MainLogo} alt="main logo" />
      </HeaderWrapper>
      <MainCoverImageWrapper>
        <MainCover src={MainCoverImage} alt="main cover" />
      </MainCoverImageWrapper>
      <RestaurantsContentsList>
        {
          state.fetchState === REQUEST_STATE.LOADING ?
            <>
              <Skeleton variant="rect" width={450} height={300} />
              <Skeleton variant="rect" width={450} height={300} />
              <Skeleton variant="rect" width={450} height={300} />
            </>
          :
            state.restaurantsList.map((item, index) =>
              <Link to={`/restaurants/${item.id}/foods`} key={index} style={{ textDecoration: 'none' }}>
                <RestaurantsContentWrapper>
                  <RestaurantsImageNode src={RestaurantImage} />
                  <MainText>{item.name}</MainText>
                  <SubText>{`配送料：${item.fee}円 ${item.time_required}分`}</SubText>
                </RestaurantsContentWrapper>
              </Link>
            )
        }
      </RestaurantsContentsList>
    </>
  )
}

const HeaderWrapper = styled.div`
  display: flex;
  justify-content: flex-start;
  padding: 8px 32px;
`;

const MainLogoImage = styled.img`
  height: 90px;
`

const MainCoverImageWrapper = styled.div`
  text-align: center;
`;

const MainCover = styled.img`
  height: 600px;
`;

const RestaurantsContentsList = styled.div`
  display: flex;
  justify-content: space-around;
  margin-bottom: 150px;
`;

const RestaurantsContentWrapper = styled.div`
  width: 450px;
  height: 300px;
  padding: 48px;
`;

const RestaurantsImageNode = styled.img`
  width: 100%;
`;

const MainText = styled.p`
  color: black;
  font-size: 18px;
`;

const SubText = styled.p`
  color: black;
  font-size: 12px;
`;


export default Restaurants
